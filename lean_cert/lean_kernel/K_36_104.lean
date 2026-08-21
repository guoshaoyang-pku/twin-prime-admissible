import Sound
import lean_certs.cert_36_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_104_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 36) (d := 104) (c := cert_36_104) (by decide)
