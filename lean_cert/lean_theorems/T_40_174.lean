import Sound
import lean_certs.cert_40_174

open CertVerify

theorem H40_gt_174 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 40) (d := 174) (c := cert_40_174) (by native_decide)
