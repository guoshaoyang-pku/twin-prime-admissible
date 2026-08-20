import Sound
import lean_certs.cert_42_180

open CertVerify

theorem H42_gt_180 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 42) (d := 180) (c := cert_42_180) (by native_decide)
