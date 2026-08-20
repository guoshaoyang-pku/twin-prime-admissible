import Sound
import lean_certs.cert_35_140

open CertVerify

theorem H35_gt_140 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 35) (d := 140) (c := cert_35_140) (by native_decide)
