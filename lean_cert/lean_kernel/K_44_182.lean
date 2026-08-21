import Sound
import lean_certs.cert_44_182

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_182_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 44) (d := 182) (c := cert_44_182) (by decide)
