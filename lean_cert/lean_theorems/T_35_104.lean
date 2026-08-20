import Sound
import lean_certs.cert_35_104

open CertVerify

theorem H35_gt_104 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 35) (d := 104) (c := cert_35_104) (by native_decide)
