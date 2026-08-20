import Sound
import lean_certs.cert_35_90

open CertVerify

theorem H35_gt_90 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 35) (d := 90) (c := cert_35_90) (by native_decide)
