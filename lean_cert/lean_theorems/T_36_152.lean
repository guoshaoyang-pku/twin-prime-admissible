import Sound
import lean_certs.cert_36_152

open CertVerify

theorem H36_gt_152 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 36) (d := 152) (c := cert_36_152) (by native_decide)
