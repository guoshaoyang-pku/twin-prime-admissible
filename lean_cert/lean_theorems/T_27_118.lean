import Sound
import lean_certs.cert_27_118

open CertVerify

theorem H27_gt_118 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 27) (d := 118) (c := cert_27_118) (by native_decide)
