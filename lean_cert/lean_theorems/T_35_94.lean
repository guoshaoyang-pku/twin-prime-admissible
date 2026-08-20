import Sound
import lean_certs.cert_35_94

open CertVerify

theorem H35_gt_94 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 35) (d := 94) (c := cert_35_94) (by native_decide)
