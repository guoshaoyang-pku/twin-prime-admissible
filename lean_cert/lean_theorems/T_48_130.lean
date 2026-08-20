import Sound
import lean_certs.cert_48_130

open CertVerify

theorem H48_gt_130 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 48) (d := 130) (c := cert_48_130) (by native_decide)
