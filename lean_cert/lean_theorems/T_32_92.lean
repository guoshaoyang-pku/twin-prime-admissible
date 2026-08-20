import Sound
import lean_certs.cert_32_92

open CertVerify

theorem H32_gt_92 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 32) (d := 92) (c := cert_32_92) (by native_decide)
