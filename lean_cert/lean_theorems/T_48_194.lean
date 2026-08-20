import Sound
import lean_certs.cert_48_194

open CertVerify

theorem H48_gt_194 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 48) (d := 194) (c := cert_48_194) (by native_decide)
