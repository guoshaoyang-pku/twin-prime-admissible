import Sound
import lean_certs.cert_35_98

open CertVerify

theorem H35_gt_98 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 35) (d := 98) (c := cert_35_98) (by native_decide)
