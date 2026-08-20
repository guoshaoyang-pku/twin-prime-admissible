import Sound
import lean_certs.cert_27_88

open CertVerify

theorem H27_gt_88 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 27) (d := 88) (c := cert_27_88) (by native_decide)
