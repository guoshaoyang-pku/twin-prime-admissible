import Sound
import lean_certs.cert_42_192

open CertVerify

theorem H42_gt_192 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 42) (d := 192) (c := cert_42_192) (by native_decide)
