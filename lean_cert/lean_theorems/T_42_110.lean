import Sound
import lean_certs.cert_42_110

open CertVerify

theorem H42_gt_110 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 42) (d := 110) (c := cert_42_110) (by native_decide)
