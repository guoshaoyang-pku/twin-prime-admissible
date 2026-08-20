import Sound
import lean_certs.cert_35_136

open CertVerify

theorem H35_gt_136 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 136 := by
  exact certValidRoot_sound (k := 35) (d := 136) (c := cert_35_136) (by native_decide)
