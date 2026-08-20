import Sound
import lean_certs.cert_42_150

open CertVerify

theorem H42_gt_150 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 42) (d := 150) (c := cert_42_150) (by native_decide)
