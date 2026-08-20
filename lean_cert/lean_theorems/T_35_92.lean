import Sound
import lean_certs.cert_35_92

open CertVerify

theorem H35_gt_92 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 35) (d := 92) (c := cert_35_92) (by native_decide)
