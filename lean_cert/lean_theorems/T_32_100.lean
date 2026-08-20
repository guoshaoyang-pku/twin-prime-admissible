import Sound
import lean_certs.cert_32_100

open CertVerify

theorem H32_gt_100 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 32) (d := 100) (c := cert_32_100) (by native_decide)
