import Sound
import lean_certs.cert_48_234

open CertVerify

theorem H48_gt_234 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 234 := by
  exact certValidRoot_sound (k := 48) (d := 234) (c := cert_48_234) (by native_decide)
