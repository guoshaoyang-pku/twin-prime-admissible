import Sound
import lean_certs.cert_48_192

open CertVerify

theorem H48_gt_192 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 48) (d := 192) (c := cert_48_192) (by native_decide)
