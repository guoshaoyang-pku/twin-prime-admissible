import Sound
import lean_certs.cert_47_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_156_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 47) (d := 156) (c := cert_47_156) (by decide)
