import Sound
import lean_certs.cert_42_124

open CertVerify

theorem H42_gt_124 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 42) (d := 124) (c := cert_42_124) (by native_decide)
