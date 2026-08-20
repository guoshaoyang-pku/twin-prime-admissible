import Sound
import lean_certs.cert_35_86

open CertVerify

theorem H35_gt_86 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 35) (d := 86) (c := cert_35_86) (by native_decide)
