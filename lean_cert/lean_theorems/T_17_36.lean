import Sound
import lean_certs.cert_17_36

open CertVerify

theorem H17_gt_36 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 17) (d := 36) (c := cert_17_36) (by native_decide)
