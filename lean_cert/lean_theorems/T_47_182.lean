import Sound
import lean_certs.cert_47_182

open CertVerify

theorem H47_gt_182 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 47) (d := 182) (c := cert_47_182) (by native_decide)
