import Sound
import lean_certs.cert_49_182

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_182_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 49) (d := 182) (c := cert_49_182) (by decide)
