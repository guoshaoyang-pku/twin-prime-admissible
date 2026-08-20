import Sound
import lean_certs.cert_37_130

open CertVerify

theorem H37_gt_130 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 130 := by
  exact certValidRoot_sound (k := 37) (d := 130) (c := cert_37_130) (by native_decide)
