import Sound
import lean_certs.cert_35_88

open CertVerify

theorem H35_gt_88 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 35) (d := 88) (c := cert_35_88) (by native_decide)
