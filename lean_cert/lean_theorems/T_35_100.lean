import Sound
import lean_certs.cert_35_100

open CertVerify

theorem H35_gt_100 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 35) (d := 100) (c := cert_35_100) (by native_decide)
