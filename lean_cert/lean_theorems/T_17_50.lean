import Sound
import lean_certs.cert_17_50

open CertVerify

theorem H17_gt_50 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 17) (d := 50) (c := cert_17_50) (by native_decide)
