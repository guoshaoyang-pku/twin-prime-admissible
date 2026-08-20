import Sound
import lean_certs.cert_27_70

open CertVerify

theorem H27_gt_70 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 27) (d := 70) (c := cert_27_70) (by native_decide)
