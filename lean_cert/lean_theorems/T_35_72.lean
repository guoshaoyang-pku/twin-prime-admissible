import Sound
import lean_certs.cert_35_72

open CertVerify

theorem H35_gt_72 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 35) (d := 72) (c := cert_35_72) (by native_decide)
