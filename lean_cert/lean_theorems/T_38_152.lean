import Sound
import lean_certs.cert_38_152

open CertVerify

theorem H38_gt_152 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 38) (d := 152) (c := cert_38_152) (by native_decide)
