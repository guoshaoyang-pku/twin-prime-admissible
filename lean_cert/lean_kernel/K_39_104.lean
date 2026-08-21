import Sound
import lean_certs.cert_39_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_104_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 39) (d := 104) (c := cert_39_104) (by decide)
