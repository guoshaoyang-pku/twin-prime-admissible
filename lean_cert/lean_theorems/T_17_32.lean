import Sound
import lean_certs.cert_17_32

open CertVerify

theorem H17_gt_32 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 17) (d := 32) (c := cert_17_32) (by native_decide)
