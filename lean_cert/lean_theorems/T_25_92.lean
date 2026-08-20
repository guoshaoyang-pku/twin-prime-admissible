import Sound
import lean_certs.cert_25_92

open CertVerify

theorem H25_gt_92 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 25) (d := 92) (c := cert_25_92) (by native_decide)
