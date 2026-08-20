import Sound
import lean_certs.cert_42_100

open CertVerify

theorem H42_gt_100 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 42) (d := 100) (c := cert_42_100) (by native_decide)
