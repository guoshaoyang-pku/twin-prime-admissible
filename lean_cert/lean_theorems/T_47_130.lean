import Sound
import lean_certs.cert_47_130

open CertVerify

theorem H47_gt_130 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 47) (d := 130) (c := cert_47_130) (by native_decide)
