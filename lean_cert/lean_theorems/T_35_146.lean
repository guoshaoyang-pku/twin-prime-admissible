import Sound
import lean_certs.cert_35_146

open CertVerify

theorem H35_gt_146 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 146 := by
  exact certValidRoot_sound (k := 35) (d := 146) (c := cert_35_146) (by native_decide)
