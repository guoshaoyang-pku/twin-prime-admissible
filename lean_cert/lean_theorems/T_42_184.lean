import Sound
import lean_certs.cert_42_184

open CertVerify

theorem H42_gt_184 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 42) (d := 184) (c := cert_42_184) (by native_decide)
