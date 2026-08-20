import Sound
import lean_certs.cert_49_130

open CertVerify

theorem H49_gt_130 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 49) (d := 130) (c := cert_49_130) (by native_decide)
