import Sound
import lean_certs.cert_39_92

open CertVerify

theorem H39_gt_92 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 39) (d := 92) (c := cert_39_92) (by native_decide)
