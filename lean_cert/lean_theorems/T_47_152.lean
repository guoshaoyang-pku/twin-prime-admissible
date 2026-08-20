import Sound
import lean_certs.cert_47_152

open CertVerify

theorem H47_gt_152 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 47) (d := 152) (c := cert_47_152) (by native_decide)
