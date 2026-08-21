import Sound
import lean_certs.cert_47_182

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_182_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 47) (d := 182) (c := cert_47_182) (by decide)
