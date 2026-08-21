import Sound
import lean_certs.cert_43_182

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_182_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 43) (d := 182) (c := cert_43_182) (by decide)
