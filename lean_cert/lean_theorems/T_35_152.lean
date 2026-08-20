import Sound
import lean_certs.cert_35_152

open CertVerify

theorem H35_gt_152 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 35) (d := 152) (c := cert_35_152) (by native_decide)
