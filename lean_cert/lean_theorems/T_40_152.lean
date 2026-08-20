import Sound
import lean_certs.cert_40_152

open CertVerify

theorem H40_gt_152 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 40) (d := 152) (c := cert_40_152) (by native_decide)
