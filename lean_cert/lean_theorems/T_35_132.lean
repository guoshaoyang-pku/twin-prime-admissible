import Sound
import lean_certs.cert_35_132

open CertVerify

theorem H35_gt_132 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 35) (d := 132) (c := cert_35_132) (by native_decide)
