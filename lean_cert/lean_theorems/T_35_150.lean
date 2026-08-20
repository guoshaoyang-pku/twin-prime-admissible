import Sound
import lean_certs.cert_35_150

open CertVerify

theorem H35_gt_150 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 35) (d := 150) (c := cert_35_150) (by native_decide)
