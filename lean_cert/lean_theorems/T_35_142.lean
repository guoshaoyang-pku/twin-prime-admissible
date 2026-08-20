import Sound
import lean_certs.cert_35_142

open CertVerify

theorem H35_gt_142 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 35) (d := 142) (c := cert_35_142) (by native_decide)
