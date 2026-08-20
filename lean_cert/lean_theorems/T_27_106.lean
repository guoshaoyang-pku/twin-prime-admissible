import Sound
import lean_certs.cert_27_106

open CertVerify

theorem H27_gt_106 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 27) (d := 106) (c := cert_27_106) (by native_decide)
