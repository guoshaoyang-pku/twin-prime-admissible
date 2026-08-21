import Sound
import lean_certs.cert_46_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_104_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 46) (d := 104) (c := cert_46_104) (by decide)
