import Sound
import lean_certs.cert_39_160

open CertVerify

theorem H39_gt_160 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 39) (d := 160) (c := cert_39_160) (by native_decide)
